import Sound
import lean_certs.cert_47_122

open CertVerify

theorem H47_gt_122 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 47) (d := 122) (c := cert_47_122) (by native_decide)
