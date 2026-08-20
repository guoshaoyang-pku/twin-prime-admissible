import Sound
import lean_certs.cert_32_120

open CertVerify

theorem H32_gt_120 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 32) (d := 120) (c := cert_32_120) (by native_decide)
