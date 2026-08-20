import Sound
import lean_certs.cert_36_80

open CertVerify

theorem H36_gt_80 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 36) (d := 80) (c := cert_36_80) (by native_decide)
