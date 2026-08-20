import Sound
import lean_certs.cert_28_122

open CertVerify

theorem H28_gt_122 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 28) (d := 122) (c := cert_28_122) (by native_decide)
