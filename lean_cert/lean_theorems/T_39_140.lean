import Sound
import lean_certs.cert_39_140

open CertVerify

theorem H39_gt_140 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 39) (d := 140) (c := cert_39_140) (by native_decide)
