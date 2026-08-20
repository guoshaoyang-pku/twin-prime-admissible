import Sound
import lean_certs.cert_40_140

open CertVerify

theorem H40_gt_140 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 40) (d := 140) (c := cert_40_140) (by native_decide)
