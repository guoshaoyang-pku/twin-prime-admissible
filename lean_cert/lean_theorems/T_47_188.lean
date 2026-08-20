import Sound
import lean_certs.cert_47_188

open CertVerify

theorem H47_gt_188 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 47) (d := 188) (c := cert_47_188) (by native_decide)
