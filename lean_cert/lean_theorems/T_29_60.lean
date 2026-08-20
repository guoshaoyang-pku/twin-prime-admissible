import Sound
import lean_certs.cert_29_60

open CertVerify

theorem H29_gt_60 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 29) (d := 60) (c := cert_29_60) (by native_decide)
