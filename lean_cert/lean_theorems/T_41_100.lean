import Sound
import lean_certs.cert_41_100

open CertVerify

theorem H41_gt_100 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 41) (d := 100) (c := cert_41_100) (by native_decide)
