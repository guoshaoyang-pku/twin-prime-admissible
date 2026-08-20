import Sound
import lean_certs.cert_47_154

open CertVerify

theorem H47_gt_154 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 47) (d := 154) (c := cert_47_154) (by native_decide)
