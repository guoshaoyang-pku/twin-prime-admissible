import Sound
import lean_certs.cert_47_192

open CertVerify

theorem H47_gt_192 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 47) (d := 192) (c := cert_47_192) (by native_decide)
