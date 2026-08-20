import Sound
import lean_certs.cert_25_100

open CertVerify

theorem H25_gt_100 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 25) (d := 100) (c := cert_25_100) (by native_decide)
