import Sound
import lean_certs.cert_35_122

open CertVerify

theorem H35_gt_122 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 35) (d := 122) (c := cert_35_122) (by native_decide)
