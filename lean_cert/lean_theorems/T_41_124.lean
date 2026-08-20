import Sound
import lean_certs.cert_41_124

open CertVerify

theorem H41_gt_124 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 41) (d := 124) (c := cert_41_124) (by native_decide)
