import Sound
import lean_certs.cert_47_216

open CertVerify

theorem H47_gt_216 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 216 := by
  exact certValidRoot_sound (k := 47) (d := 216) (c := cert_47_216) (by native_decide)
