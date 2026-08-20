import Sound
import lean_certs.cert_25_64

open CertVerify

theorem H25_gt_64 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 25) (d := 64) (c := cert_25_64) (by native_decide)
