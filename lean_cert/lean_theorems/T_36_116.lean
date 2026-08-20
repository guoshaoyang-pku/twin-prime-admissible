import Sound
import lean_certs.cert_36_116

open CertVerify

theorem H36_gt_116 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 36) (d := 116) (c := cert_36_116) (by native_decide)
