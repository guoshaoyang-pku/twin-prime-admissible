import Sound
import lean_certs.cert_24_60

open CertVerify

theorem H24_gt_60 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 24) (d := 60) (c := cert_24_60) (by native_decide)
