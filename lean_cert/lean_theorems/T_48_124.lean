import Sound
import lean_certs.cert_48_124

open CertVerify

theorem H48_gt_124 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 48) (d := 124) (c := cert_48_124) (by native_decide)
