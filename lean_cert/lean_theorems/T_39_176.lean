import Sound
import lean_certs.cert_39_176

open CertVerify

theorem H39_gt_176 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 39) (d := 176) (c := cert_39_176) (by native_decide)
