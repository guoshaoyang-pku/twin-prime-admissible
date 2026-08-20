import Sound
import lean_certs.cert_36_140

open CertVerify

theorem H36_gt_140 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 36) (d := 140) (c := cert_36_140) (by native_decide)
