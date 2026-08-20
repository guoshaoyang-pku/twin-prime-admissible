import Sound
import lean_certs.cert_39_138

open CertVerify

theorem H39_gt_138 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 39) (d := 138) (c := cert_39_138) (by native_decide)
