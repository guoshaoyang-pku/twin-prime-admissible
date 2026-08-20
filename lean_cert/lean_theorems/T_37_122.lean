import Sound
import lean_certs.cert_37_122

open CertVerify

theorem H37_gt_122 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 37) (d := 122) (c := cert_37_122) (by native_decide)
