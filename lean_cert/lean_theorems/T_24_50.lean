import Sound
import lean_certs.cert_24_50

open CertVerify

theorem H24_gt_50 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 24) (d := 50) (c := cert_24_50) (by native_decide)
