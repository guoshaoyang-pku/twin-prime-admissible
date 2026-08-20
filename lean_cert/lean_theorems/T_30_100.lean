import Sound
import lean_certs.cert_30_100

open CertVerify

theorem H30_gt_100 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 30) (d := 100) (c := cert_30_100) (by native_decide)
