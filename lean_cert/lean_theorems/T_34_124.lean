import Sound
import lean_certs.cert_34_124

open CertVerify

theorem H34_gt_124 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 34) (d := 124) (c := cert_34_124) (by native_decide)
