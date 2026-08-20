import Sound
import lean_certs.cert_36_108

open CertVerify

theorem H36_gt_108 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 36) (d := 108) (c := cert_36_108) (by native_decide)
