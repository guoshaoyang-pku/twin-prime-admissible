import Sound
import lean_certs.cert_36_124

open CertVerify

theorem H36_gt_124 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 36) (d := 124) (c := cert_36_124) (by native_decide)
