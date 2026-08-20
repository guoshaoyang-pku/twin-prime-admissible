import Sound
import lean_certs.cert_47_138

open CertVerify

theorem H47_gt_138 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 47) (d := 138) (c := cert_47_138) (by native_decide)
