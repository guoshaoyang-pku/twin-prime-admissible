import Sound
import lean_certs.cert_49_150

open CertVerify

theorem H49_gt_150 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 49) (d := 150) (c := cert_49_150) (by native_decide)
