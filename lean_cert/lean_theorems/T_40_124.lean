import Sound
import lean_certs.cert_40_124

open CertVerify

theorem H40_gt_124 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 40) (d := 124) (c := cert_40_124) (by native_decide)
