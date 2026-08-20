import Sound
import lean_certs.cert_34_122

open CertVerify

theorem H34_gt_122 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 34) (d := 122) (c := cert_34_122) (by native_decide)
