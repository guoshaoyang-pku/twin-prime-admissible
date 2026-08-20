import Sound
import lean_certs.cert_47_174

open CertVerify

theorem H47_gt_174 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 47) (d := 174) (c := cert_47_174) (by native_decide)
