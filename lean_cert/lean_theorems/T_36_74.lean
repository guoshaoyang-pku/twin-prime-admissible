import Sound
import lean_certs.cert_36_74

open CertVerify

theorem H36_gt_74 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 36) (d := 74) (c := cert_36_74) (by native_decide)
