import Sound
import lean_certs.cert_33_72

open CertVerify

theorem H33_gt_72 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 33) (d := 72) (c := cert_33_72) (by native_decide)
