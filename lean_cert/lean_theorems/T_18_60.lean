import Sound
import lean_certs.cert_18_60

open CertVerify

theorem H18_gt_60 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 18) (d := 60) (c := cert_18_60) (by native_decide)
