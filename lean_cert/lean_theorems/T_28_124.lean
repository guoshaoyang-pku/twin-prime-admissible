import Sound
import lean_certs.cert_28_124

open CertVerify

theorem H28_gt_124 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 28) (d := 124) (c := cert_28_124) (by native_decide)
