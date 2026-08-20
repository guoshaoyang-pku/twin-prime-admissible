import Sound
import lean_certs.cert_47_198

open CertVerify

theorem H47_gt_198 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 47) (d := 198) (c := cert_47_198) (by native_decide)
