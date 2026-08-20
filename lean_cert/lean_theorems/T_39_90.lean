import Sound
import lean_certs.cert_39_90

open CertVerify

theorem H39_gt_90 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 39) (d := 90) (c := cert_39_90) (by native_decide)
