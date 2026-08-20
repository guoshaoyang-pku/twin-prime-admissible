import Sound
import lean_certs.cert_40_122

open CertVerify

theorem H40_gt_122 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 40) (d := 122) (c := cert_40_122) (by native_decide)
