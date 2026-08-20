import Sound
import lean_certs.cert_25_60

open CertVerify

theorem H25_gt_60 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 25) (d := 60) (c := cert_25_60) (by native_decide)
