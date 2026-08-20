import Sound
import lean_certs.cert_49_124

open CertVerify

theorem H49_gt_124 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 49) (d := 124) (c := cert_49_124) (by native_decide)
