import Sound
import lean_certs.cert_30_124

open CertVerify

theorem H30_gt_124 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 30) (d := 124) (c := cert_30_124) (by native_decide)
