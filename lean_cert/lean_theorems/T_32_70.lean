import Sound
import lean_certs.cert_32_70

open CertVerify

theorem H32_gt_70 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 32) (d := 70) (c := cert_32_70) (by native_decide)
