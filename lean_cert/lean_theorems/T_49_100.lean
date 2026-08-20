import Sound
import lean_certs.cert_49_100

open CertVerify

theorem H49_gt_100 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 49) (d := 100) (c := cert_49_100) (by native_decide)
