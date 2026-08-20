import Sound
import lean_certs.cert_22_60

open CertVerify

theorem H22_gt_60 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 22) (d := 60) (c := cert_22_60) (by native_decide)
