import Sound
import lean_certs.cert_29_124

open CertVerify

theorem H29_gt_124 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 29) (d := 124) (c := cert_29_124) (by native_decide)
