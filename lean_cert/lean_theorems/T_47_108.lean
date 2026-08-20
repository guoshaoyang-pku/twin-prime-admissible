import Sound
import lean_certs.cert_47_108

open CertVerify

theorem H47_gt_108 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 47) (d := 108) (c := cert_47_108) (by native_decide)
