import Sound
import lean_certs.cert_24_64

open CertVerify

theorem H24_gt_64 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 24) (d := 64) (c := cert_24_64) (by native_decide)
