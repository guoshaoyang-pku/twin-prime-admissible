import Sound
import lean_certs.cert_31_124

open CertVerify

theorem H31_gt_124 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 31) (d := 124) (c := cert_31_124) (by native_decide)
