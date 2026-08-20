import Sound
import lean_certs.cert_33_122

open CertVerify

theorem H33_gt_122 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 33) (d := 122) (c := cert_33_122) (by native_decide)
