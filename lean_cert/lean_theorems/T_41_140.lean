import Sound
import lean_certs.cert_41_140

open CertVerify

theorem H41_gt_140 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 41) (d := 140) (c := cert_41_140) (by native_decide)
