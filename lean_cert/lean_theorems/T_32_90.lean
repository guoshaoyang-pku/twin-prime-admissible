import Sound
import lean_certs.cert_32_90

open CertVerify

theorem H32_gt_90 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 32) (d := 90) (c := cert_32_90) (by native_decide)
