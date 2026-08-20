import Sound
import lean_certs.cert_39_116

open CertVerify

theorem H39_gt_116 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 39) (d := 116) (c := cert_39_116) (by native_decide)
