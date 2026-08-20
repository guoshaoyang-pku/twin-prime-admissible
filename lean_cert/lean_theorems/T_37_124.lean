import Sound
import lean_certs.cert_37_124

open CertVerify

theorem H37_gt_124 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 37) (d := 124) (c := cert_37_124) (by native_decide)
