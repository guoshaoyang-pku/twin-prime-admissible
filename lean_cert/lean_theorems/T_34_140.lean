import Sound
import lean_certs.cert_34_140

open CertVerify

theorem H34_gt_140 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 34) (d := 140) (c := cert_34_140) (by native_decide)
